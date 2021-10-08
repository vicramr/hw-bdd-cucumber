# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create(movie)
  end
end

Then /(.*) seed movies should exist/ do | n_seeds |
  expect(Movie.count).to eq n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  my_regex = /#{e1}.*#{e2}/
  expect(my_regex.match?(page.body))
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  verb = uncheck ? "uncheck" : "check"
  rating_list.split(', ').each do |rating|
    steps %Q{
      When I #{verb} "ratings[#{rating}]"
    }
  end
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table

  # Find the HTML table using capybara, then count the number of
  # rows in it, then compare that to the number of rows
  # in the table
  tab = page.find(id: "movies")
  rows = tab.all("tr") # adapted from here: https://goois.net/parse-html-tables-cucumber-recipes.html
  expect(rows.length - 1).to eq (Movie.count) # Subtract 1 to account for header

  # Useful capybara docs:
  # https://rubydoc.info/github/teamcapybara/capybara/master/Capybara/Node/Finders#find-instance_method
  # https://rubydoc.info/github/teamcapybara/capybara/master/Capybara/Node/Finders#all-instance_method
end
