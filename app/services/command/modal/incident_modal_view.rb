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
        "submit": {
            "type": "plain_text",
            "text": "Submit"
        },
        "blocks": blocks
      }
    end
  
    private
  
  def blocks
    [
        {
            "type": "input", # Use input block instead of section with accessory
            "block_id": "incident_title_section",
            "label": {
              "type": "plain_text",
              "text": "*Confirm the incident title:*"
            },
            "element": {
              "type": "plain_text_input", # This is the input type for plain text
              "action_id": "incident_title_input",
              "placeholder": {
                "type": "plain_text",
                "text": "Enter a short title for the incident"
              },
              "initial_value": "" # Optional: Set an initial value if needed
            }
        },
          # Input block for the Incident Description field
          {
            "type": "input", # Input block to handle description
            "block_id": "incident_description_section",
            "label": {
              "type": "plain_text",
              "text": "*Describe the incident:*"
            },
            "element": {
              "type": "plain_text_input", # This is the input type for plain text
              "action_id": "incident_description_input",
              "multiline": true, # Multiline allows longer text entry
              "placeholder": {
                "type": "plain_text",
                "text": "Enter a detailed description of the incident"
              },
              "initial_value": "" # Optional: Set an initial value if needed
            }
          },
          # Input block for the Severity Level dropdown (static select)
          {
            "type": "input", # Input block for dropdown
            "block_id": "incident_severity_section",
            "label": {
              "type": "plain_text",
              "text": "*Select the severity level:*"
            },
            "element": {
              "type": "static_select",
              "action_id": "incident_severity_select",
              "placeholder": {
                "type": "plain_text",
                "text": "Choose severity"
              },
              "options": severity_options
            }
          },
        {
          "block_id": "channel_selection_block",
          "type": "input",
          "optional": true,
          "label": {
            "type": "plain_text",
            "text": "Channel to send success message to"
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
            "response_url_enabled": true,
            "default_to_current_conversation": true
          }
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
  