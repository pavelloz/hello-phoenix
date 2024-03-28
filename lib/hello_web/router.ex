defmodule HelloWeb.Router do
  use HelloWeb, :router

  # Pipeline for the browser requests
  #
  # The `:browser` pipeline is used in the router to match the
  # request to the appropriate pipeline for processing. It sets up
  # a pipeline with common browser-related plugins.
  #
  # The `:accepts` plug is responsible for setting the request format
  # to HTML, as we only handle HTML in the browser.
  #
  # The `:fetch_session` plug is responsible for storing session
  # data in the cookie and retrieving from it when a request is made.
  #
  # `:fetch_live_flash` plug is responsible for sending and
  # fetching flash messages from the session.
  #
  # `:put_root_layout` plug is responsible for setting the layout
  # to be used in the browser. The layout is set to `root.html.heex`
  # in the `HelloWeb.Layouts` module.
  #
  # `:protect_from_forgery` plug is responsible for protecting the
  # application against cross-site request forgery (CSRF) attacks.
  #
  # `:put_secure_browser_headers` plug is responsible for setting
  # some basic security headers.
  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {HelloWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HelloWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", HelloWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:hello, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: HelloWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview

      forward "/admin", Crawly.API.Router
    end
  end
end
