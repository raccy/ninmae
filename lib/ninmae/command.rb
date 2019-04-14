# frozen_string_literal: true

class Ninmae
  class Command
    def run_cmd(argv)
      case argv[0]
      when 'htaccess'
        print <<-"HTACCESS"
  \# ninmae
  ErrorDocument 403 /ninmae/api?action=redirect
  Require expr HTTP_COOKIE =~ /ninmae_session=(\\d+):([\\da-f]+);/ && \\
    $1 -ge %{TIME} && \\
    $2 == md5('#{name}$1#{secret_session}')
        HTACCESS
      when nil
        print <<-"INFO"
  ninmae ver. #{VERSION}
  name: #{name}
  path: #{path}
  secret status: #{check_secret ? 'ok' : 'ng'}
  number of problems: #{problems.size}
        INFO
      end
    end

  end
end
