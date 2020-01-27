require "bundler/setup"
require "faker"

count = (ARGV.first || 100).to_i

outputs = []

titles = {}
basenames = {}

count.times do
  Faker::Config.locale = :ja
  title = Faker::Lorem.sentence
  titles[title] = titles[title].to_i + 1
  if titles[title] > 1
    title = "#{title} (#{titles[title]})"
  end
  primary_category = Faker::Book.genre
  category = Faker::Book.genre
  body = Faker::Lorem.paragraphs(number: 1..5).join("\n")
  extended_body = Faker::Lorem.paragraphs(number: rand(20..50)).join("\n")
  keywords = Faker::Lorem.words
  tags = Faker::Lorem.words

  Faker::Config.locale = :en
  basename = Faker::Lorem.words(number: (1..3)).join("-")
  basenames[basename] = basenames[basename].to_i + 1
  if basenames[basename] > 1
    basename = "#{basename}_#{basenames[basename]}"
  end

  text = <<"EOF"
AUTHOR: admin
TITLE: #{title}
BASENAME: #{basename}
STATUS: Publish
ALLOW COMMENTS: 0
CONVERT BREAKS: __default__
ALLOW PINGS: 0
PRIMARY CATEGORY: #{primary_category}
CATEGORY: #{primary_category}
CATEGORY: #{category}
DATE: #{(Time.now - rand(6000 * 60 * 60 * 24)).strftime("%m/%d/%Y %I:%M:%S %p")}
TAGS: #{tags.join(",")}
-----
BODY:
#{body}
-----
EXTENDED BODY:
#{extended_body}
-----
EXCERPT:

-----
KEYWORDS:
#{keywords.join(",")}
-----


-----
--------
EOF
  outputs.push(text)
end

puts outputs.join("\n")
