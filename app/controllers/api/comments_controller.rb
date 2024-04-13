# app/controllers/api/comments_controller.rb

module Api
    class CommentsController < ApplicationController
      protect_from_forgery with: :null_session
      before_action :set_feature
  
      # POST /api/features/:feature_id/comments
      def create
        @comment = @feature.comments.build(comment_params)
  
        if @comment.save
          render json: @comment, status: :created
        else
          render json: @comment.errors, status: :unprocessable_entity
        end
      end

      #get /api/features/:feature_id/comments
      def index
        @comments = @feature.comments
        render json: @comments
      end

      def show
        @comment = @feature.comments.find(params[:id])
        render json: @comment
      end
  
      private
  
      def set_feature
        @feature = Feature.find(params[:feature_id])
      end
  
      def comment_params
        params.require(:comment).permit(:body)
      end
    end
  end
  