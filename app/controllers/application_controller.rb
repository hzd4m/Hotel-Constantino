class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  def index
  end

  def after_sign_in_path_for(resource)
    return authenticated_root_path if resource.respond_to?(:admin?) && resource.admin?

    if resource.respond_to?(:hospede_record) && resource.hospede_record.present?
      guest_reservas_path
    else
      authenticated_root_path
    end
  end

  def after_sign_up_path_for(resource)
    after_sign_in_path_for(resource)
  end

  protected

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  def require_admin!
    return if current_user&.admin?

    redirect_to authenticated_root_path, alert: "Acesso permitido apenas para administradores."
  end
end
