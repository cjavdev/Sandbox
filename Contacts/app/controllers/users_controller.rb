class UsersController < ApplicationController

  def favorites
    favorites = Contact.where(user_id: params[:id], is_favorite: 1)
    render :json => favorites
  end

  def index
    users = User.all
    render :json => users
  end

  def create

    user = User.new(params[:user])

    if user.save
      render :json => user
    else
      render :json => user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    user = User.find(params[:id])
    if user.destroy
      render :json => "Destroyed"
    else
      render :json => user.errors, status: :unprocessable_entity
    end
  end

  def show
    user = User.find(params[:id])
    render :json => user
  end

  def login
    if !params.has_key?(:login)
      return false
    else
      user = User.where(params[:login]).first
      unless user
        render :json => "invalid login", status: :unprocessable_entity
      else
        user.token = "54321"
        user.save
        render :json => user
      end
    end
  end

  def logout
    if params.has_key?(:token)
      user = User.where(params[:token]).first
      if user
        user.token = nil
        user.save
        render :json => "Logout successful! Peace muthafucka"
      else
        render :json => "Invalid token"
      end
    else
      render :json => "Invalid token!"
    end
  end
end