# -*- coding: utf-8 -*-
class PokesController < ApplicationController
  def create
    begin
      if current_user.friend?(poke_target_param[:target])
        if User.where(name: poke_target_param[:target]).count > 0
          @poke = Poke.new(poke_params)
          @poke.target = User.where(name: poke_target_param[:target]).first
          @poke.author = current_user
          if @poke.save
            redirect_to root_path, flash: { notice: "つんつんしました！"}
          else
            redirect_to root_path, flash: { error: "Document Saving Error"}
          end
        else
          current_user.invite(poke_target_param[:target])
          redirect_to root_path, flash: {notice: "@#{poke_target_param[:target]}を招待しました！"}
        end
      else
        redirect_to root_path, flash: {error: "Not Friend!"}
      end
    rescue
      redirect_to root_path, flash: {error: " We're sorry.but something went wrong."}
    end
  end

  def reply
    begin
      if @poke = Poke.find(params[:id])
        if !@poke.open
          @poke.open = true
          @poke.save
        end
        @reply = Poke.new
        @reply.author = current_user
        @reply.target = @poke.author
        if @reply.save
          redirect_to root_path, flash: { notice: "つんつんしました！"}
        else
          redirect_to root_path, flash: { error: "Document Saving Error"}
        end
      else
        redirect_to root_path, flash: {error: " Not Found."}
      end
    rescue
      redirect_to root_path, flash: {error: " We're sorry.but something went wrong."}
    end
  end

  def show
    begin
      if @poke = Poke.find(params[:id])
        if !@poke.open
          @poke.open = true
          @poke.save
        end
      else
        redirect_to root_path, flash: {error: " Not Found."}
      end
    rescue
      redirect_to root_path, flash: {error: " We're sorry.but something went wrong."}
    end
  end

  def destroy
    begin
      @poke = Poke.find(params[:id])
      @poke.delete
    end
    redirect_to root_path
  end

  private
  def poke_params
    params.require(:poke).permit(:time, :message, :image)
  end

  def poke_target_param
    params.require(:poke).permit(:target)
  end

end
