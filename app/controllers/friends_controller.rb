class FriendsController < ApplicationController
  before_action :authenticate_user!

  def create
    user = User.find_by login_id: params[:login_id]
    render json: {errors: ['指定されたユーザは存在しません']}, status: :bad_request and return if user.nil?
    friend = @current_user.friends_from.create to_user_id: user[:id]
    render json: {errors: friend.errors.full_messages}, status: :bad_request and return if friend.errors.any?
    render json: {} and return
  end

  def index
    friend_ids = @current_user.friends_from_user_ids + @current_user.friends_to_user_ids
    friend_ids.uniq!
    render json: {} and return if friend_ids.empty?
    friends = User.where(id: friend_ids).order('id DESC')
    render json: {friends: friends.map { |friend| {id: friend[:id], login_id: friend[:login_id], name: friend[:name], icon_file_name: friend[:icon_file_name]} }} and return
  end

  def show
    # 友達検索
    friends = User.where("name LIKE ?", "%#{params[:id]}%").order('id DESC')
    render json: {friends: friends.map { |friend| {id: friend[:id], login_id: friend[:login_id], name: friend[:name], icon_file_name: friend[:icon_file_name]} }} and return
  end
end
