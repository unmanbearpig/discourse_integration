class DiscourseSsoController < ApplicationController
  before_action :authenticate_user!

  # TODO:
  #   - Extract to some class?
  #   - Make user able to log in if not logged in
  #   - How to test it?
  #   - Add name, username to user
  #   - What is suppress_welcome_message?
  #   - Add avatars later
  #   - Ability to update user profile, sync with discourse
  #   - Figure out how to migrate users from Discourse to SSO
  def authenticate
    sso.email = current_user.email
    sso.external_id = current_user.id

    redirect_to sso.to_url
  end

  private

  def sso
    # TODO: .parse can throw RuntimeError,
    #       make sure we handle it
    @sso ||= DiscourseApi::SingleSignOn
           .parse(request.query_string, DISCOURSE_SSO_SECRET)
           .tap { |sso| sso.sso_url = DISCOURSE_SSO_URL }
  end
end
