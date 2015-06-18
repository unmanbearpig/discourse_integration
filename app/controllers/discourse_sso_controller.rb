class DiscourseSsoController < ApplicationController
  # TODO:
  #   - Extract to some class?
  #   - How to test it?
  #   - Add name, username to user
  #   - What is suppress_welcome_message?
  #   - Add avatars later
  #   - Ability to update user profile, sync with discourse
  #   - Figure out how to migrate users from Discourse to SSO
  def authenticate
    unless signed_in?
      store_location_for :user, request.fullpath
    end

    authenticate_user!

    sso.email = current_user.email
    sso.external_id = current_user.id

    redirect_to sso.to_url
  end

  private

  def query_string
    if request.query_string.blank?
      raise RuntimeError.new 'No payload was provided'
    end

    request.query_string
  end

  def sso
    # TODO: .parse can throw RuntimeError,
    #       make sure we handle it
    @sso ||= DiscourseApi::SingleSignOn
           .parse(query_string, DISCOURSE_SSO_SECRET)
           .tap { |sso| sso.sso_url = DISCOURSE_SSO_URL }
  end
end
