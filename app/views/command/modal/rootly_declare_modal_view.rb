
class Command::Rootly::IncidentModalView
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
        {
      "type": "section",
      "block_id": "incident_title_section",
      "text": {
        "type": "mrkdwn",
        "text": "*Confirm the incident title:*"
      },
      "accessory": {
        "type": "plain_text_input",
        "action_id": "incident_title_input",
        "placeholder": {
          "type": "plain_text",
          "text": "Enter a short title for the incident"
          }
        }
      },
        # Section for the Incident Description input field
        {
          "type": "section",
          "block_id": "incident_description_section",
          "text": {
            "type": "mrkdwn",
            "text": "*Describe the incident:*"
          },
          "accessory": {
            "type": "plain_text_input",
            "action_id": "incident_description_input",
            "multiline": true,
            "placeholder": {
              "type": "plain_text",
              "text": "Enter a detailed description of the incident"
            }
          }
        },
        # Section for the Severity Level dropdown
        {
          "type": "section",
          "block_id": "incident_severity_section",
          "text": {
            "type": "mrkdwn",
            "text": "*Select the severity level:*"
          },
          "accessory": {
            "type": "static_select",
            "action_id": "incident_severity_select",
            "placeholder": {
              "type": "plain_text",
              "text": "Choose severity"
            },
            "options": severity_options
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
  