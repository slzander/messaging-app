class MessageFilterService
  def initialize(user, message_params)
    @user = user
    @sender_id = message_params[:sender_id] if message_params.key?(:sender_id)
  end

  def filter
    user_messages
  end

  private

  def user_messages
    messages = Message.where(recipient_id: @user.id)
    messages = messages.where(sender_id: @sender_id) unless @sender_id.nil?

    filter_within_last_month(messages)
  end

  def filter_within_last_month(messages)
    filtered_messages = messages.where('created_at > ?', 30.days.ago)
    filter_by_count_limit(filtered_messages)
  end

  def filter_by_count_limit(messages)
    filtered_messages = messages.limit(100)
    sort(filtered_messages)
  end

  def sort(messages)
    messages.order(created_at: :desc)
  end
end