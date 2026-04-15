module Message::Broadcastable
  extend ActiveSupport::Concern

  included do
    broadcasts_to ->(message) { "chat_#{message.chat_id}" }, inserts_by: :append
  end

  def broadcast_append_chunk(chunk_content)
    broadcast_append_to stream_name,
      target: content_target,
      content: escaped_content(chunk_content)
  end

  private

    def stream_name
      "chat_#{chat_id}"
    end

    def content_target
      "message_#{id}_content"
    end

    def escaped_content(content)
      ERB::Util.html_escape(content.to_s)
    end
end
