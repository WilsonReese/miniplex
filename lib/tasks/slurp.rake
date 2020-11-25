namespace :slurp do
  desc "TODO"
  task movies: :environment do
    Movie.destroy_all

    require "csv"

    csv_text = File.read(Rails.root.join("lib", "csvs", "movie_sample_data.csv"))
    csv = CSV.parse(csv_text, :headers => true, :encoding => "ISO-8859-1")
    puts csv
    csv.each do |row|
      m = Movie.new
      m.id = row["movie_id"]
      m.currently_showing = row["currently_showing"]
      m.description = row["description"]
      m.duration = row["duration"]
      m.image = row["image"]
      m.title = row["title"]
      m.created_at = row["created_at"]
      m.updated_at = row["updated_at"]
      m.save
      puts "#{m.title} saved"
    end
  end

end
