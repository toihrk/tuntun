class WelcomeController < ApplicationController
  def index
    @users = User.all

    if user_signed_in?
      @poke = Poke.new
      @pokes = current_user.poked + current_user.targeted
      @pokes.sort!{ |a, b|
        b.created_at <=> a.created_at
      }
    end

  end

end
