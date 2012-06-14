
Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
#   puts "debug #{movie.inspect}"
    m = Movie.new
    m.title = movie[:title]
    m.rating = movie[:rating]
    m.release_date = movie[:release_date]
    m.save!
  end
end

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  page.content.match(/#{e1}.*#{e2}/)
end

When /I (un)?check the following ratings: "(.*)"/ do |uncheck, rating_list|
  rating_list.sub("\"","").split.each do |rating|
    puts "debug [#{rating}]"

    if uncheck == "un"
      uncheck("ratings[#{rating}]")
    else
      check("ratings[#{rating}]")
    end
  end
end

When /I press "(.*)"/ do |button|
  click_button(button.sub("\"",""))
end
