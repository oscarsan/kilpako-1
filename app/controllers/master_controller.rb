class MasterController < ApplicationController
  # Master controller assures that only admins and masters of events that the object
  # mentioned in the controller can edit the object. In addition, users that are
  # not admins should only see in index action objects they owni - with exception of
  # the events - which are all public. Other objects (competitions, applications etc)
  # can only be viewed per parent (competition of an event, applications for a competirion).
  # Most of that needs to be implemented by the actual controller, but this base
  # gives helpers.

  # Each sub-controller must implement set_object (which gets generated by scaffold
  # generator as set_XXX, and must implement owns_object? by calling owns_event? on
  # the event that that object belongs to.

  # Basically, before_action handlers are listed here, it is very likely sub-
  # -controllers should not have any.

  before_action :set_object, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:show, :index]
  before_action only: [:index] do |controller|
    if controller.class != EventsController
      authenticate_user!
    end
  end
  before_action :owns_object?, only: [:edit, :update, :destroy] do |controller|
    raise ActionController::RoutingError.new("Not Found") unless owns_object?
  end

protected

  def owns_event?(event)
    current_user.admin? or event.masters.exists? current_user
  end

end
