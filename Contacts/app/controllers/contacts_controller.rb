require 'set'
class ContactsController < ApplicationController
  before_filter :auth_user

  def index
    contacts = Contact.where(user_id: params[:user_id]).all
    render :json => contacts
  end

  def create
    contact = Contact.new(params[:contact])
    contact.user_id = params[:user_id]
    if contact.save
      render :json => contact
    else
      render :json => contact.errors, status: :unprocessable_entity
    end
  end

  def show
    contact = Contact.where(user_id: params[:user_id], id: params[:id]).first

    render :json => contact
  end

  def update
    contact = Contact.where(user_id: params[:user_id], id: params[:id]).first

    contact.name = params[:contact][:name]
    contact.email = params[:contact][:email]
    contact.mail_address = params[:contact][:mail_address]
    contact.phone = params[:contact][:phone]

    if contact.save
      render :json => contact
    else
      render :json => contact.errors, status: :unprocessable_entity
    end
  end

  def destroy
    contact = Contact.where(user_id: params[:user_id], id: params[:id]).first

    if contact.destroy
      render :json => "destroyed!"
    else
      render :json => contact.errors, status: :unprocessable_entity
    end
  end

  def search
    unwanted_attrs = ['action', 'controller', 'token'].to_set

    contact = Contact.where(params.reject{|key| unwanted_attrs.include?(key)}).all

    if contact.empty?
      render :json => "no contacts found!"
    else
      render :json => contact
    end
  end

  private
  def auth_user
    if params.has_key?(:token)
      user = User.where(token: params[:token]).first
      user.id == params[:user_id]
    else
      render :json => "Invalid token"
    end
  end
end


