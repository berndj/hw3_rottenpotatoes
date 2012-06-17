
Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
#   puts "debug db filling #{movie.inspect}"
    m = Movie.new
    m.title = movie[:title]
    m.rating = movie[:rating]
    m.release_date = movie[:release_date]
    m.save!
  end
end

#Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
#  puts "debug [#{e1} before #{e2}]"
#  assert page.body.match(/.*#{e1}.*#{e2}/m) != nil
#end

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|

  pos1=0
  pos2=0
  page.body.split("\n").each do |str|
    if str.match(/#{e1}/) != nil
      break
    else
      pos1 += 1
    end
  end
  page.body.split(" ").each do |str|
    #    puts "debug [#{str}]"
    if str.match(/#{e2}/) != nil
      break
    else
      pos2 += 1
    end
  end
#  puts "debug [#{page.body}]"

  puts "debug [#{pos1} before #{pos2}]"
  assert pos1 < pos2
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

Then /I should ?(not)? see movies with ratings: (.*)/ do |uncheck, rating_list|

  rating_list.gsub(" ","").split(",").each do |rating|
    Movie.find_each do |movie|
      if movie.rating == rating
#        debugger
        if uncheck != "no"
          assert page.body.include?(movie.title), "#{movie.title}:#{movie.rating} found"
        else
          assert page.body.include?(movie.title)==false, "no: #{movie.title}:#{movie.rating} found"
        end
      end
    end
  end
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

  Movie.find_each do |movie|
      # puts "no: #{movie.title}"
      assert page.has_content?(movie.title)==false if check == "no"
      assert page.has_content?(movie.title) if check == "all"
  end

end


When /I press "(.*)"/ do |button|
  click_button(button.sub("\"",""))
end

