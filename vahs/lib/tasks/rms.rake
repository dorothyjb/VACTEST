desc "configure the rms database"
namespace :rms do
  task :config do
    print "Hostname: "
    hostname = STDIN.gets.chomp

    print "Port: "
    hostport = STDIN.gets.chomp

    print "SID: "
    sid = STDIN.gets.chomp

    print "Username: "
    username = STDIN.gets.chomp

    print "Password: "
    password = STDIN.noecho(&:gets).chomp
    puts

    print "Password (verification): "
    password2 = STDIN.noecho(&:gets).chomp
    puts

    if password != password2
      puts "Password doesn't match\nExiting."
      exit 1
    end

    cfg = Rms::Config::Database.new(Rms::Config::Database::Config::PATH)
    cfg.update(hostname, hostport, sid, username, password)
    cfg.write
  end
end
