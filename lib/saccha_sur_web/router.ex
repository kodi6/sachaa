defmodule SacchaSurWeb.Router do
  use SacchaSurWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SacchaSurWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :brow do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SacchaSurWeb.Layouts, :root}
    plug :put_secure_browser_headers
  end

  scope "/", SacchaSurWeb do
    pipe_through :brow
    post "/verify_payment", PageController, :verify_payment

  end

  scope "/", SacchaSurWeb do
    pipe_through :browser


      live "/tellmeastory.guru/story", SacchaSurLive.Index, :story
      live "/tellmeastory.guru/buy", SacchaSurLive.Index, :checkout
      live "/tellmeastory.guru", SacchaSurLive.Index, :index
      live "/pay", PayLive.Index, :index

  end

  # Other scopes may use custom stacks.
  # scope "/api", SacchaSurWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:saccha_sur, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: SacchaSurWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
