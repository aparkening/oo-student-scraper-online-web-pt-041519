require 'nokogiri'
require 'open-uri'
class Scraper

  # Return array of student hashes 
  def self.scrape_index_page(index_url)
    students = []

    # Store html, get profiles
    doc = Nokogiri::HTML(open(index_url))
    student_profiles = doc.css("div.roster-cards-container .student-card")

    # Iterate through profiles, create student hashes
    student_profiles.collect do |student| 
      students <<
      {
        :name => student.css(".card-text-container h4.student-name").text, 
        :location => student.css(".card-text-container p.student-location").text, 
        :profile_url => student.css("a").attr("href").value
      }
    end
    return students
  end

  # Return hash describing individual student
  def self.scrape_profile_page(profile_url)
    profile = {}

    # Store html document
    doc = Nokogiri::HTML(open(profile_url))

    # Store main vitals
    vitals_container = doc.css("div.profile .vitals-container").first

    # Set social urls if they exist
    twitter = ""
    linkedin = ""
    github = ""
    blog = ""
    links = vitals_container.css(".social-icon-container a").each do |link| 
      if link.attr("href").include?("twitter.com") 
        profile[:twitter] = link.attr("href")
      elsif link.attr("href").include?("linkedin.com") 
        profile[:linkedin] = link.attr("href")
      elsif  link.attr("href").include?("github.com") 
        profile[:github] = link.attr("href")
      elsif  link.attr("href").include?("facebook.com") 
        facebook = link.attr("href")
      else 
        profile[:blog] = link.attr("href")
      end
    end

    # # Grab twitter url if it exists, via css attribute
    # twitter = vitals_container.css(".social-icon-container a[href*='twitter.com']").attr("href").value if vitals_container.css(".social-icon-container a[href*='twitter.com']").first 

    # Get profile quote and bio if they exist
    profile[:profile_quote] = vitals_container.css(".vitals-text-container .profile-quote").text if profile[:profile_quote] = vitals_container.css(".vitals-text-container .profile-quote").first
    
    profile[:bio] = doc.css("div.profile .details-container p").first.text if profile[:bio] = doc.css("div.profile .details-container p").first

    return profile
  end
end