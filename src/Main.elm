module Main exposing (main)

import Browser
import FontAwesome as Icon exposing (Icon)
import FontAwesome.Attributes as Icon
import FontAwesome.Brands as Icon
import FontAwesome.Solid as Icon
import FontAwesome.Styles as Icon
import Html exposing (a, div, h1, text)
import Html.Attributes exposing (..)
import Html.Lazy exposing (lazy2)
import Process
import Random
import String
import Task
import Time


type alias Model =
    { prompt : String, title_text : String, command : String, typing : Bool }


type Msg
    = TypeCommand
    | StopTyping
    | DelayTypeCommand Int


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model "$" "" "./onn.sh" True, Cmd.none )


main : Program () Model Msg
main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }


view : Model -> Html.Html msg
view model =
    div
        [ class "flex flex-col min-h-screen dark:bg-prime-black bg-prime-white-bg p-2" ]
        [ Icon.css
        , lazy2 title model.prompt model.title_text
        , link_icons onnen_links
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TypeCommand ->
            ( type_command model, Random.generate DelayTypeCommand (Random.int 100 1000) )

        StopTyping ->
            ( { model | typing = False }, Cmd.none )

        DelayTypeCommand delay ->
            ( model, Process.sleep (toFloat delay) |> Task.perform (always TypeCommand) )


type_command : Model -> Model
type_command model =
    if String.isEmpty model.command then
        { model | typing = False }

    else
        { model
            | title_text = model.title_text ++ String.left 1 model.command
            , command = String.dropLeft 1 model.command
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.typing then
        Time.every 500 (always TypeCommand)

    else
        Sub.none


title : String -> String -> Html.Html msg
title prompt title_text =
    div [ class "flex flex-row" ]
        [ h1 [ class title_font_style, class "dark:text-prime-purple text-prime-purple-lt" ] [ text prompt ]
        , h1 [ class title_font_style, class "dark:text-prime-white text-prime-black-txt" ] [ text title_text ]
        , h1 [ class title_font_style, class "text-prime-gray animate-blink" ] [ text "▊" ]
        ]


type alias Link =
    { name : String, url : String, icon : Icon Icon.WithoutId }


onnen_links : List Link
onnen_links =
    [ Link "GitHub" "https://github.com/onnenon" Icon.github
    , Link "LinkedIn" "https://linkedin.com/in/sconnen" Icon.linkedin
    , Link "Email" "mailto:stephen.onnen@gmail.com" Icon.envelope
    ]


link_icons : List Link -> Html.Html msg
link_icons links =
    links
        |> List.map link_icon
        |> div [ class "flex flex-row justify-start" ]


link_icon : Link -> Html.Html msg
link_icon link =
    a
        [ class "flex-shrink text-prime-gray-lt dark:text-prime-gray hover:dark:text-prime-white hover:text-prime-black md:text-4xl text-[7vw] p-[.8em] md:p-[1em]"
        , href link.url
        ]
        [ Icon.view link.icon ]


title_font_style : String
title_font_style =
    "flex font-mono select-none md:text-8xl text-[14vw]"
