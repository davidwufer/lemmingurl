class UrlsController < ApplicationController

  def new
    @url = Url.new
    @title = "LemmingUrl"
    respond_to do |format|
      logger.info "Responding to #{format}"
      format.html
      format.js
    end
  end

  def create
    @url = Url.new(params[:url])
    if @url.save
      respond_to do |format|
        format.html { redirect_to @url }
        format.js
      end
    else
      logger.info "Invalid URL entered."
      logger.info "Errors: #{@url.errors.messages}"
      flash.now[:error] = 'Please enter a valid URL'
      render 'new'
    end
  end

  def show
    # TODO: Return a stub URL for all URLs not in the db?
    @url = Url.find_by_secret_token(params[:id])
  end

  # Used for visiting a certain URL using a token.
  def visit
    @url = Url.find_by_secret_token(params[:id])
    if @url
      url = @url.url
      @url.destroy
      redirect_to url
    else
      flash[:error] = 'URL does not exist'
      redirect_to root_path
    end
  end
end
