# HearingList — AI-Powered Music Discovery

> A conversational assistant for discovering songs, artists and live cover versions.

HearingList is a collaborative Ruby on Rails application built during the Le Wagon Web Development bootcamp. It combines a music catalogue with an AI assistant that helps users explore songs, artists and live covers through a natural conversation.

## Features

* Secure authentication and user accounts with Devise
* Persistent chats and message history
* Context-aware AI conversations powered by RubyLLM
* Search for live cover versions on YouTube
* AI tool calling to create artists, songs and versions from a conversation
* Automatic chat-title generation from the first user message
* Dynamic conversations with Turbo Streams
* Input validation and a limit of 10 user messages per chat

## Tech stack

* Ruby on Rails 8
* PostgreSQL
* RubyLLM
* Turbo and Stimulus
* JavaScript
* Bootstrap
* Devise
* Cloudinary

## Team workflow

This project was delivered collaboratively using feature branches, pull requests and code reviews. It was an opportunity to design prompts, integrate LLM capabilities into a Rails application and deliver an AI feature with clear product constraints.

## What I learned

* Integrating an LLM into a Rails application with RubyLLM
* Building prompt instructions and maintaining conversational context
* Using tool calling to connect an AI assistant to application actions
* Streaming dynamic user interactions with Turbo Streams
* Designing guardrails for an AI-powered user experience
