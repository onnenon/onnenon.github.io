module Main exposing (main)

-- import Html.Lazy exposing (lazy)

import Browser
import FontAwesome as Icon exposing (Icon)
import FontAwesome.Attributes as Icon
import FontAwesome.Brands as Icon
import FontAwesome.Solid as Icon
import FontAwesome.Styles as Icon
import Html exposing (Html, a, div, h1, text)
import Html.Attributes exposing (..)
import Process
import Random
import Task
import Time


type alias Model =
    { time : TimeInfo
    , title : TitleState
    , prompt : String
    }


type alias TimeInfo =
    { current : Time.Posix
    , zone : Time.Zone
    }


type alias TitleState =
    { displayed : String
    , remaining : String
    , typing : Bool
    }


type alias Link =
    { name : String, url : String, icon : Icon Icon.WithoutId }


type Msg
    = ContinueTyping
    | CompleteTyping
    | ScheduleNextCharacter Int
    | TimeUpdate Time.Posix
    | AdjustTimeZone Time.Zone


type alias PromptSegment =
    { text : String, style : String }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { time =
            { current = Time.millisToPosix 0
            , zone = Time.utc
            }
      , title =
            { typing = True
            , displayed = ""
            , remaining = "./onn.sh"
            }
      , prompt = "λ"
      }
    , getTime
    )


main : Program () Model Msg
main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ContinueTyping ->
            ( processNextCharacter model, Random.generate ScheduleNextCharacter (Random.int 100 1000) )

        CompleteTyping ->
            ( { model | title = { displayed = model.title.displayed, remaining = model.title.remaining, typing = False } }, Cmd.none )

        ScheduleNextCharacter delay ->
            ( model, Process.sleep (toFloat delay) |> Task.perform (always ContinueTyping) )

        TimeUpdate time ->
            ( { model | time = { current = time, zone = model.time.zone } }, Task.perform AdjustTimeZone Time.here )

        AdjustTimeZone zone ->
            ( { model | time = { current = model.time.current, zone = zone } }, Cmd.none )


padInt : Int -> String
padInt num =
    if num < 10 then
        "0" ++ String.fromInt num

    else
        String.fromInt num


view : Model -> Html msg
view model =
    let
        hour =
            padInt (Time.toHour model.time.zone model.time.current)

        minute =
            padInt (Time.toMinute model.time.zone model.time.current)

        time =
            hour ++ ":" ++ minute
    in
    div
        [ class "flex flex-col min-h-screen dark:bg-catppuccin-mocha-mantle bg-catppuccin-latte-mantle p-2 leading-tight" ]
        [ Icon.css
        , promptTopRow <| promptTopParts time
        , title model
        , linkIcons
        ]


processNextCharacter : Model -> Model
processNextCharacter model =
    if String.isEmpty model.title.remaining then
        { model | title = { displayed = model.title.displayed, remaining = model.title.remaining, typing = False } }

    else
        let
            nextChar =
                String.left 1 model.title.remaining

            remaining =
                String.dropLeft 1 model.title.remaining

            newTitle =
                { displayed = model.title.displayed ++ nextChar
                , remaining = remaining
                , typing = model.title.typing
                }
        in
        { model | title = newTitle }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ if model.title.typing then
            Time.every 500 (always ContinueTyping)

          else
            Sub.none
        , Time.every 1000 TimeUpdate
        ]


shouldBlink : Model -> Bool
shouldBlink model =
    not model.title.typing


title : Model -> Html msg
title model =
    div [ class "flex flex-row" ]
        [ h1
            [ class titleFontStyle, class "dark:text-catppuccin-mocha-muave text-catppuccin-latte-muave pr-6 font-bold" ]
            [ text model.prompt ]
        , h1 [ class titleFontStyle, class "dark:text-catppuccin-mocha-text text-catppuccin-latte-text" ] [ text model.title.displayed ]
        , h1 [ class titleFontStyle, class "dark:text-catppuccin-mocha-overlay text-catppuccin-latte-overlay flex", classList [ ( "animate-blink", shouldBlink model ) ] ] [ text "▇" ]
        ]


promptTopRow : List PromptSegment -> Html msg
promptTopRow parts =
    parts
        |> List.map (\part -> div [ class part.style ] [ text part.text ])
        |> div
            [ class "flex md:text-4xl text-[4.5vw] font-mono mb-2 font-bold select-none" ]


promptTopParts : String -> List PromptSegment
promptTopParts time =
    [ PromptSegment time "text-catppuccin-latte-green dark:text-catppuccin-mocha-green pr-4"
    , PromptSegment "-" "text-catppuccin-latte-peach dark:text-catppuccin-mocha-peach pr-4"
    , PromptSegment "sonnen" "text-catppuccin-latte-maroon dark:text-catppuccin-mocha-maroon"
    , PromptSegment "@onnen.dev" "text-catppuccin-latte-sapphire dark:text-catppuccin-mocha-sapphire pr-4"
    , PromptSegment "[" "text-catppuccin-latte-sapphire dark:text-catppuccin-mocha-sapphire"
    , PromptSegment "~" "text-catppuccin-latte-subtext dark:text-catppuccin-mocha-subtext"
    , PromptSegment "]" "text-catppuccin-latte-sapphire dark:text-catppuccin-mocha-sapphire"
    ]


linkIcons : Html msg
linkIcons =
    let
        links =
            [ Link "GitHub" "https://github.com/onnenon" Icon.github
            , Link "LinkedIn" "https://linkedin.com/in/sconnen" Icon.linkedin
            , Link "Email" "mailto:stephen.onnen@gmail.com" Icon.envelope
            ]
    in
    links
        |> List.map linkIcon
        |> div [ class "flex flex-row justify-start" ]


linkIcon : Link -> Html msg
linkIcon link =
    a
        [ class "shrink  md:text-4xl text-[7vw] p-[.8em] md:p-[1em]"
        , class "text-catppuccin-latte-overlay dark:text-catppuccin-mocha-overlay dark:hover:text-catppuccin-mocha-subtext hover:text-catppuccin-latte-subtext"
        , href link.url
        ]
        [ Icon.view link.icon ]


titleFontStyle : String
titleFontStyle =
    "flex font-mono select-none md:text-8xl text-[14vw]"


getTime : Cmd Msg
getTime =
    Task.perform TimeUpdate Time.now
