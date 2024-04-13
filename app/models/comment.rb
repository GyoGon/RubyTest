class Comment < ApplicationRecord
    belongs_to :feature
  
    # Validaciones
    validates_presence_of :body
  end