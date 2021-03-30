#!/usr/bin/env ruby

require "nokogiri"

class Problem
  attr :url, :name

  def initialize url, name
    @url = url
    @name = name
  end

  def to_s
    "Problem #{name} -> #{url}"
  end
end

def load_problems
  # File has been received from a link you can find in notes.org
  parsed_data = Nokogiri::HTML.parse File.read("./Sheet1.html")

  tags = parsed_data.xpath "//a"

  tags.map do |tag|
    Problem.new tag[:href], tag.text
  end
end

def substitute line, problem
  substitution = "[[#{problem.url}][#{problem.name}]]"
  line.gsub!(problem.name, substitution)
  line
end


# Programm

file = File.open("./notes.org")

problems = load_problems
current_line = 0
output = ""

# We are using the fact that lines in notes are the same as in
# xml document
file.each do |line|
  if line =~ /^\|\s*[0-9]+\s*\|/
    problem = problems[current_line]
    current_line += 1
    output << substitute(line, problem)
  else
    output << line
  end
end


File.write("./notes.org", output)
