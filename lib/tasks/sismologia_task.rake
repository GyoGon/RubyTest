require 'net/http'
require 'json'
namespace :db do
    desc "upload data from the sismologia API to the database"
    #fetching data from the API
    task :sismologia_task => :environment do
        url = 'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson'
        response = Net::HTTP.get_response(URI(url))
        #status code 200
        if response.code == '200'
            data = JSON.parse(response.body)
            features = data['features']

        features.each do |feature|
                #puts "Processing feature #{feature['geometry']}"
                #puts "Processing feature #{feature['properties']}"

                #verify null values
                next if feature['properties']['title'].nil? || feature['properties']['url'].nil? || feature['properties']['place'].nil? ||  feature['properties']['magType'].nil? || feature['geometry']['coordinates'][0].nil? || feature['geometry']['coordinates'][1].nil?
                #puts "Processing feature #{feature['geometry']}"
                #verify range values
                properties = feature['properties']
                geometry = feature['geometry']
                magnitude = feature['properties']['mag'].to_f
                latitude = geometry['coordinates'][1].to_f
                longitude = geometry['coordinates'][0].to_f
                
                next if magnitude < -1.0 || magnitude > 10.0 || latitude < -90.0 || latitude > 90.0 || longitude < -180.0 || longitude > 180.0

                #extracting other properties
                place = properties['place']
                time = Time.at(properties['time'] / 1000)
                url = properties['url']
                tsunami = properties['tsunami']
                mag_type = properties['magType']
                title = properties['title']
                

                #validate duplicate values
                existing_feature = Feature.find_by(external_id: feature['id'])
                next if existing_feature.present?
                    
                    #create new feature
                    feature_instance = Feature.new(
                        external_id: feature['id'],
                        magnitude: magnitude,
                        place: place,
                        time: time,
                        url: url,
                        tsunami: tsunami,
                        mag_type: mag_type,
                        title: title,
                        longitude: longitude,
                        latitude: latitude
                    )

                    # Intentar guardar la instancia de Feature
                    if feature_instance.save!
                    puts "Feature #{feature_instance.external_id} saved successfully."
                    else
                    puts "Failed to save Feature #{feature_instance.external_id}. Errors: #{feature_instance.errors.full_messages.join(", ")}"
                    end
                end
        else
            puts "Error: #{response.status}"
            puts "Tipo de response.status: #{response.status.class}"
            puts "Mensaje de error: #{response.message}"
        end
    end
end

#program execution

