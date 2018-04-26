class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  before_action :reject_cross_origin_request, except: [:icon, :doanswer]

  @current_user = nil

  private

  def log_in(user)
    session[:id] = user.id
    generate_token user
  end

  def log_out()
    session.delete(:id)
  end

  def generate_token(user)
    payload = {id: user.id}
    JWT.encode payload, Rails.application.secrets.secret_key_base, 'HS256'
  end

  def reject_cross_origin_request
    render :nothing => true, :status => :bad_request and return unless request.headers['X-Requested-With']
  end

  def authenticate_user!
    @current_user = User.find_by(id: session[:id])
    render :nothing => true, :status => :forbidden and return if @current_user.nil?
  end
end
