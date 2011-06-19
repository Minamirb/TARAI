# -*- coding: utf-8 -*-
def notify(title, message, image)
  system "notify-send '#{title}' '#{message}' -i '#{image}' -t 2000"
end

def run_withnotify(*files)
  image_root = File.expand_path("~/.autotest_images")
  puts "Running: #{files.join(' ')}"
  puts results = `bundle exec rspec -f p -c #{files.join(' ')}`
  output, _, fail_count, _, pending_count = 
    */(\d+)\sexamples?,\s(\d+)\sfailures?(,\s(\d+)\spendings?)?/.match(results)


  if fail_count.to_i > 0
    notify "FAIL", "#{output}", "#{image_root}/fail.png"
  elsif pending_count.to_i > 0
    notify "Pending", "#{output}", "#{image_root}/pending.png"
  else
    notify "Pass", "#{output}", "#{image_root}/pass.png"
  end
  no_int_for_you
end

def run_all_specs
  run_withnotify *Dir["spec/**/*_spec.rb"]
end

# ----------------------------------------------------------------------
# Signal Hacking
# ----------------------------------------------------------------------
def no_int_for_you
  @sent_an_int = nil
end

Signal.trap 'INT' do 
  if @sent_an_int
    puts "  A second INT? ok, I get the message, Shutting down now..."
    exit
  else
    puts "  Did you just send me an INT Ugh. I'll quit for real if you do it again."
    @sent_an_int = true
    Kernel.sleep 1.5
    run_all_specs
  end
end

# ----------------------------------------------------------------------
# check SASS file
# ----------------------------------------------------------------------
def check_sass(file)
  system("clear; bundle exec sass --check public/stylesheet/sass#{file}")
end

# spec ファイルを修正したら、それを実行する
watch("spec/.*/*_spec\.rb") do |match|
  run_withnotify match[0]
end

# app/model/xx.rb を修正したら、spec/model/xx_spec.rb を実行する
# app/controllers/yy.rb を修正したら、 spec/controllers/yy_spec.rb を実行する
# などなど
watch("app/(.*/.*)\.rb") do |match|
  run_withnotify %{spec/#{match[1]}_spec.rb}
end

watch("app/views/(.*)/.*\.html\.erb") do |match|
  if match[1] == "layouts"
    run_withnotify *Dir["spec/requests/*_spec.rb"]
  else
    run_withnotify %{spec/requests/#{match[1]}_spec.rb}
  end
end

watch("config/routes.rb") do |match|
  run_withnotify *Dir["spec/routing/*_spec.rb"]
end

# .sass ファイルを修正したら、その整合性をチェックする


