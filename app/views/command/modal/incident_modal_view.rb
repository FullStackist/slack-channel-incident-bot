
class Command::Modal::IncidentModalView
    def initialize(incident_title)
      @incident_title = incident_title
    end
  
    def render
      {
        "type": "modal",
        "callback_id": "incident_modal",
        "title": {
          "type": "plain_text",
          "text": "Incident: #{@incident_title}",
          "emoji": true
        },
        "blocks": blocks
      }
    end
  
    private
  
    def blocks
      [
        # Section for confirming Incident title

        # Section for selecting a channel to post the result on
        {
          "block_id": "channel_selection_block",
          "type": "input",
          "optional": true,
          "label": {
            "type": "plain_text",
            "text": "Select a channel to post the result on"
          },
          "element": {
            "type": "conversations_select",
            "action_id": "channel_forwarder",
            "placeholder": {
              "type": "plain_text",
              "text": "Choose a channel"
            },
            "filter": {
              "include": ["public", "private"] 
            },
            "response_url_enabled": true
          }
        },
        # Section for the Submit Button
        {
          "type": "actions",
          "block_id": "incident_submit_section",
          "elements": [
            {
              "type": "button",
              "text": {
                "type": "plain_text",
                "text": "Submit Incident"
              },
              "action_id": "submit_incident_button",
              "style": "primary" # Style can be "primary" or "danger"
            }
          ]
        }
      ]
    end
  
    def severity_options
      [
        {
          "text": {
            "type": "plain_text",
            "text": "High"
          },
          "value": "high"
        },
        {
          "text": {
            "type": "plain_text",
            "text": "Medium"
          },
          "value": "medium"
        },
        {
          "text": {
            "type": "plain_text",
            "text": "Low"
          },
          "value": "low"
        }
      ]
    end
  end
  