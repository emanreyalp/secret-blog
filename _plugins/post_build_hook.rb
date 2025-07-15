Jekyll::Hooks.register :site, :post_write do |site|
  puts "--> Encypting files in _site directory..."

  # Check if staticrypt is installed
  unless system("which staticrypt > /dev/null 2>&1")
    puts "Error: staticrypt is not installed."
    exit 1
  end
  # Ensure the ENCRYPT_PASSWORD environment variable is set
  unless ENV['ENCRYPT_PASSWORD']
    puts "Error: ENCRYPT_PASSWORD environment variable is not set."
    exit 1
  end
  # Encrypt the files in the _site directory
  unless system("staticrypt _site/* -r -d _site -p #{ENV.fetch('ENCRYPT_PASSWORD')}")
    puts "Error: Failed to encrypt files in _site directory."
    exit 1
  end
  # Check if the encryption was successful
  lines = IO.readlines("_site/index.html")
  unless lines[1].include?('staticrypt-html')
    puts "Error: Encryption did not complete successfully."
    exit 1
  end

  puts "-->  Encryption completed."

  puts "--> Checking for feed.xml file in _site directory..."
  if File.exist?("_site/feed.xml")
    puts "Error: rss file exists"
    exit 1
  end
end
