class Feature < ApplicationRecord
    has_many :comments
  
    # Validaciones
    validates_presence_of :magnitude, :place, :mag_type, :title, :longitude, :latitude
    validates_uniqueness_of :external_id
    validates :magnitude, numericality: { greater_than_or_equal_to: -1.0, less_than_or_equal_to: 10.0 }
    validates :latitude, numericality: { greater_than_or_equal_to: -90.0, less_than_or_equal_to: 90.0 }
    validates :longitude, numericality: { greater_than_or_equal_to: -180.0, less_than_or_equal_to: 180.0 }
end