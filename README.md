# Channel-Driven Incident Management

## Manage incidents directly in Slack

This service allows you to manage incidents directly within Slack, enabling seamless interaction with incident data right inside your workspace. It integrates with Slack’s API, allowing you to `Declare` incidents as they arise and `Resolve` incidents as they're handled.

---

## Install

Click [here to install in your Slack Workspace](https://slack.com/oauth/v2/authorize?client_id=8574621697570.8575781185571&scope=commands,channels:manage,groups:write,im:write,mpim:write&user_scope=)

---

## Basic Usage

Once the app is installed, you can start managing incidents directly within Slack. Here are the basic steps to get started:

1. **Declare an Incident:**
   - Type `/rootly declare <your-incident-title>` in any Slack channel to begin a new incident.
    - **A new channel is created with name `<your-incident-title>_incident` (e.g. `/rootly declare Leaky Faucet` creates channel `leakyfaucet_incident`)**
    - **To join the channel, search for it in the workspace searchbar, find it, click into it and click `join`**
    - **The created incident is now marked as `open`**
   
2. **Resolve an Incident**
   - Type `/rootly resolve` in your `<your-incident-title>_incident` channel to mark this incident as `resolved`.
    - **The time it took for the team to resolve the incident will be written to the channel**
    - **Another incident taken care of!**

3. **View all Incidents**
    - Go [here](https://slack-channel-incident-bot.onrender.com/incidents) to see a pretty display of all Incidents.
     - **Use the sorting functionality to see how the Incidents compare in terms of their different attributes**
     
---

## Technical Highlights

- ✅ Builtin OAuth for Slack
- ✅ Tailwind CSS & View Components
- ✅ Extensible backend, leaning heavily into the use of services `/services`
- ✅ Highly-readable code resulting from a DRY, facade-based approach for most services

**🚀 Thank you for your consideration! I look forward to the next steps 🚀**