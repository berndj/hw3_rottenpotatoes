
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
  # puts "debug [#{page.methods}]"
  page.body.match(/#{e1}.*#{e2}/)

end

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.gsub(" ","").split(",").each do |rating|
#    puts "debug [#{rating}]"

    if uncheck == "un"
      uncheck("ratings[#{rating}]")
    else
      check("ratings[#{rating}]")
    end
  end
end

Then /I should ?(not|)? see movies with ratings: (.*)/ do |uncheck, rating_list|
  val = true

  #  puts "debug [#{rating}]"
  if uncheck == false
    return true
  end
  Movie.find_each do |movie|
    if page.body.include?(movie.title)
      found = false
      rating_list.gsub(" ","").split(",").each do |rating|
        if movie.rating == rating
          found=true
        end
      end
      if false==found
        val=false
        break
      end
    end
  end

  val
end


When /I (un)?check all ratings/ do |uncheck|
  Movie.all_ratings.each do |rating|
    if uncheck == "un"
      uncheck("ratings[#{rating}]")
    else
      check("ratings[#{rating}]")
    end
  end
end

Then /I should see (all|none) of the movies/ do |check|
  val = true
  # puts "#{page.body}"
  if check == "no"
    Movie.find_each do |movie|
      # puts "no: #{movie.title}"
      if page.body.include?(movie.title)
        val = false
        # puts "no: break false"
        break
      end
    end
  elsif check == "all"
    Movie.find_each do |movie|
      # puts "all: #{movie.title}"
      if page.body.include?(movie.title)==false
        val = false
        break
      end
    end
  else
    val = false
  end

  val
end




When /I press "(.*)"/ do |button|
  click_button(button.sub("\"",""))
end

