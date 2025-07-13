Jekyll::Hooks.register :site, :post_write do |site|
  puts "--> Encypting files in _site directory..."
  # puts ENV['ENCRYPT_PASSWORD']
  system("staticrypt _site/* -r -d _site -p #{ENV.fetch('ENCRYPT_PASSWORD')}")
  puts "-->  Encryption completed."
end
