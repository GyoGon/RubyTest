# app/controllers/api/features_controller.rb

module Api
  class FeaturesController < ApplicationController
    before_action :set_feature, only: [:show, :create_comment]

    def index
      # Obtener todos los mag_types válidos
      valid_mag_types = ['md', 'ml', 'ms', 'mw', 'me', 'mi', 'mb', 'mlg']

      # GET /api/features
      #@features = Feature.order(created_at: :desc)
      @features = @features.where(mag_type: params[:mag_type]) if params[:mag_type].present? && valid_mag_types.include?(params[:mag_type])
      @features = Feature.order(time: :desc).page(params[:page]).per(10)
      
      # Renderizar los resultados
      render json: ( {
        data: @features.map { |feature| format_feature(feature) },
        pagination: {
          current_page: @features.current_page,
          total: @features.total_count,
          per_page: @features.limit_value
        }
      })
    end

    # POST /api/features/:feature_id/comments
    def create_comment
      @comment = @feature.comments.build(comment_params)

      if @comment.save
        render json: @comment, status: :created
      else
        render json: @comment.errors, status: :unprocessable_entity
      end
    end

    def show
      # GET /api/features/:id
      @feature = Feature.find(params[:id])
      render json: @feature
    end

    def create
    end

    def update
    end

    def destroy
    end

    private

    def set_feature
      @feature = Feature.find(params[:id])
    end

    # Método privado para dar formato al feature según lo requerido
    def format_feature(feature)
      {
        data: [
          {
            id: feature.id,
            type: 'feature',
            attributes: {
              external_id: feature.external_id,
              type: 'feature',
              magnitude: feature.magnitude,
              place: feature.place,
              time: feature.time.to_s,
              tsunami: feature.tsunami,
              mag_type: feature.mag_type,
              title: feature.title,
              coordinates: {
                longitude: feature.longitude,
                latitude: feature.latitude
              }
            },
            links: {
              external_url: feature.url
            }
          }
        ],
        pagination: {
          current_page: @features.current_page,
          total: @features.total_count,
          per_page: @features.limit_value
        }
      }
    end

    def comment_params
      params.require(:comment).permit(:body)
    end
  end
end
