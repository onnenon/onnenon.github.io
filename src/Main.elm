module Main exposing (main)

import Browser
import FontAwesome as Icon exposing (Icon)
import FontAwesome.Attributes as Icon
import FontAwesome.Brands as Icon
import FontAwesome.Solid as Icon
import FontAwesome.Styles as Icon
import Html exposing (Html, a, div, h1, text)
import Html.Attributes exposing (..)
import Html.Lazy exposing (lazy)
import Process
import Random
import Task
import Time


type alias Model =
    { currentTime : Time.Posix
    , timeZone : Time.Zone
    , prompt : String
    , title_text : String
    , command : String
    , typing : Bool
    }


type alias Link =
    { name : String, url : String, icon : Icon Icon.WithoutId }


type Msg
    = TypeCommand
    | StopTyping
    | DelayTypeCommand Int
    | TimeUpdate Time.Posix
    | AdjustTimeZone Time.Zone


type alias StyledText =
    { text : String, style : String }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model (Time.millisToPosix 0) Time.utc "λ" "" "./onn.sh" True, getTime )


main : Program () Model Msg
main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TypeCommand ->
            ( typeCommand model, Random.generate DelayTypeCommand (Random.int 100 1000) )

        StopTyping ->
            ( { model | typing = False }, Cmd.none )

        DelayTypeCommand delay ->
            ( model, Process.sleep (toFloat delay) |> Task.perform (always TypeCommand) )

        TimeUpdate time ->
            ( { model | currentTime = time }, Task.perform AdjustTimeZone Time.here )

        AdjustTimeZone zone ->
            ( { model | timeZone = zone }, Cmd.none )


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
            padInt (Time.toHour model.timeZone model.currentTime)

        minute =
            padInt (Time.toMinute model.timeZone model.currentTime)

        time =
            hour ++ ":" ++ minute
    in
    div
        [ class "flex flex-col min-h-screen dark:bg-prime-dark-black bg-prime-light-white p-2 leading-tight" ]
        [ Icon.css
        , promptTopRow <| promptTopParts time
        , lazy title model
        , linkIcons
        ]


typeCommand : Model -> Model
typeCommand model =
    if String.isEmpty model.command then
        { model | typing = False }

    else
        { model
            | title_text = model.title_text ++ String.left 1 model.command
            , command = String.dropLeft 1 model.command
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ if model.typing then
            Time.every 500 (always TypeCommand)

          else
            Sub.none
        , Time.every 1000 TimeUpdate
        ]


title : Model -> Html msg
title model =
    div [ class "flex flex-row" ]
        [ h1
            [ class titleFontStyle, class "dark:text-prime-dark-purple text-prime-light-purple pr-6 font-bold" ]
            [ text model.prompt ]
        , h1 [ class titleFontStyle, class "dark:text-prime-dark-white text-prime-light-black" ] [ text model.title_text ]
        , h1 [ class titleFontStyle, class "text-prime-dark-gray flex", classList [ ( "animate-blink", not model.typing ) ] ] [ text "▇" ]
        ]


promptTopRow : List StyledText -> Html msg
promptTopRow parts =
    parts
        |> List.map (\part -> div [ class part.style ] [ text part.text ])
        |> div
            [ class "flex md:text-4xl text-[4.5vw] font-mono mb-2 font-bold select-none" ]


promptTopParts : String -> List StyledText
promptTopParts time =
    [ StyledText time "text-prime-light-green dark:text-prime-dark-red pr-4"
    , StyledText "-" "text-prime-light-yellow dark:text-prime-dark-yellow pr-4"
    , StyledText "sonnen" "text-prime-light-purple dark:text-prime-dark-purple"
    , StyledText "@onnen.dev" "text-prime-light-blue dark:text-prime-dark-blue pr-4"
    , StyledText "[" "text-prime-light-blue dark:text-prime-dark-blue"
    , StyledText "~" "text-prime-light-gray dark:text-prime-dark-gray"
    , StyledText "]" "text-prime-light-blue dark:text-prime-dark-blue"
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
        , class "text-prime-light-gray dark:text-prime-dark-gray dark:hover:text-prime-dark-white hover:text-prime-light-black"
        , href link.url
        ]
        [ Icon.view link.icon ]


titleFontStyle : String
titleFontStyle =
    "flex font-mono select-none md:text-8xl text-[14vw]"


getTime : Cmd Msg
getTime =
    Task.perform TimeUpdate Time.now
