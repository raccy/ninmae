# frozen_string_literal: true

class Ninmae
  class Cgi
    def run_cgi(cgi)
      session_time = check_session(cgi.cookies)
      if session_time && within_validity_period?(session_time)
      end


      case cgi['action']
      when nil, ''
        run_default(cgi)
      when 'retrieve'
        run_retrieve
      when 'answer'
        run_answer
      end
    end

    # require 'json'
    # cgi.out('apllication/json') do
    #   {
    #     status: 'error',
    #     error: e.message,
    #   }.to_json
    # end

  end
end
