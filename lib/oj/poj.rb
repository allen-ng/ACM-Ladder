require 'net/http'
require 'open-uri'

# TODO: handles errors
module POJ
  BaseURL = "http://poj.org"
  Handle = ENV['POJ_HANDLE']
  Password = ENV['POJ_PASSWORD']

  LangCollection = {
    "C (gcc)"		=> OJ::LangSymToID[:c],
    "C++ (g++)"		=> OJ::LangSymToID[:cpp],
    "Java (jdk6)"	=> OJ::LangSymToID[:java],
    "Pascal (fpc)"	=> OJ::LangSymToID[:pascal]
  }
  LangSubmitID = {
    OJ::LangSymToID[:c]		=> 1,
    OJ::LangSymToID[:cpp]	=> 0,
    OJ::LangSymToID[:java]	=> 2,
    OJ::LangSymToID[:pascal]	=> 3
  }

  class << self
    def submit(submission)
      uri = URI(BaseURL)
      language = LangSubmitID[submission.language]
      Net::HTTP.start(uri.host, uri.port) do |http|
        uri = URI("#{BaseURL}/login")
        request = Net::HTTP::Post.new(uri.request_uri)
        request.set_form_data({ 'user_id1' => Handle, 'password1' => Password, 'B1' => 'login', 'url' => '.' })
        response = http.request(request)
        cookies = response.response['set-cookie']

        uri = URI("#{BaseURL}/submit")
        request = Net::HTTP::Post.new(uri.request_uri)
        request['Cookie'] = cookies
        request.set_form_data({ 'problem_id' => submission.problem.original_id,
                                'language' => language,
                                'source' => submission.code,
                                'encoded' => '0'})
        response = http.request(request)
      end

      sleep 1

      submission.original_id = nil	# for rejudge
      status = :wait
      while [:wait, :comp, :run].include?(status)
        doc = Hpricot(open("#{BaseURL}/status?problem_id=#{submission.problem.original_id}&user_id=#{Handle}"))
        result = doc.search("table")[4].search("tr")[1].search("td")

        submission.original_id ||= result[0].inner_html

        status = result[3].at("font").inner_html
        status = OJ::StatusNameToSym[status =~ /Running/ ? "Running" : status]
        submission.status = OJ::StatusSymToID[status]
        if status == :ac
          submission.memory = result[4].inner_html[/\d+/]
          submission.time = result[5].inner_html[/\d+/]
        elsif status == :ce
          doc = Hpricot(open("#{BaseURL}/showcompileinfo?solution_id=#{submission.original_id}"))
          submission.error = doc.at("pre").inner_html
        end

        submission.save
      end
    end

    def fetch(problem)
      doc = Hpricot(open(url = "#{BaseURL}/problem?id=#{problem.original_id}"))

      result = doc.at("div.ptt")
      return if result.nil?
      problem.title = result.inner_html

      for item in doc/"img"
        item['src'] = "#{BaseURL}/" + item['src']
      end

      result = doc/"div.plm td"
      problem.time_limit = result[0].inner_html[/\d+/]
      problem.memory_limit = result[2].inner_html[/\d+/]

      result = doc/"div.ptx"
      problem.description = result[0].inner_html
      problem.input = result[1].inner_html
      problem.output = result[2].inner_html
      problem.hint = result[3].inner_html if doc.search("p.pst").inner_html.include?("Hint")

      result = doc/"pre.sio"
      problem.sample_input = result[0].inner_html
      problem.sample_output = result[1].inner_html
    end
  end
end
