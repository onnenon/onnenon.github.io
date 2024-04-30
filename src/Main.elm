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
import Task
import Time


type alias Model =
    { prompt : String, title_text : String, command : String, typing : Bool }


type alias Link =
    { name : String, url : String, icon : Icon Icon.WithoutId }


type Msg
    = TypeCommand
    | StopTyping
    | DelayTypeCommand Int


type alias StyledText =
    { text : String, style : String }


onnen_links : List Link
onnen_links =
    [ Link "GitHub" "https://github.com/onnenon" Icon.github
    , Link "LinkedIn" "https://linkedin.com/in/sconnen" Icon.linkedin
    , Link "Email" "mailto:stephen.onnen@gmail.com" Icon.envelope
    ]


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model "λ" "" "./onn.sh" True, Cmd.none )


main : Program () Model Msg
main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TypeCommand ->
            ( type_command model, Random.generate DelayTypeCommand (Random.int 100 1000) )

        StopTyping ->
            ( { model | typing = False }, Cmd.none )

        DelayTypeCommand delay ->
            ( model, Process.sleep (toFloat delay) |> Task.perform (always TypeCommand) )


view : Model -> Html.Html msg
view model =
    div
        [ class "flex flex-col min-h-screen dark:bg-prime-dark-black bg-prime-light-white p-2" ]
        [ Icon.css
        , prompt_top_row prompt_top_parts
        , lazy2 title model.prompt model.title_text
        , link_icons onnen_links
        ]


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
        [ h1
            [ class title_font_style, class "dark:text-prime-dark-purple text-prime-light-purple pr-6 font-bold" ]
            [ text prompt ]
        , h1 [ class title_font_style, class "dark:text-prime-dark-white text-prime-light-black" ] [ text title_text ]
        , h1 [ class title_font_style, class "text-prime-dark-gray animate-blink" ] [ text "▊" ]
        ]


prompt_top_row : List StyledText -> Html.Html msg
prompt_top_row parts =
    parts
        |> List.map (\part -> div [ class part.style ] [ text part.text ])
        |> div
            [ class "flex md:text-4xl text-[4.5vw] font-mono mb-2 font-bold" ]


prompt_top_parts : List StyledText
prompt_top_parts =
    [ StyledText "11:39AM" "text-prime-light-red dark:text-prime-dark-red pr-4"
    , StyledText "-" "text-prime-light-yellow dark:text-prime-dark-yellow pr-4"
    , StyledText "sonnen" "text-prime-light-purple dark:text-prime-dark-purple"
    , StyledText "@onnen.dev" "text-prime-light-blue dark:text-prime-dark-blue pr-4"
    , StyledText "[" "text-prime-light-blue dark:text-prime-dark-blue"
    , StyledText "~" "text-prime-light-gray dark:text-prime-dark-gray"
    , StyledText "]" "text-prime-light-blue dark:text-prime-dark-blue"
    ]


link_icons : List Link -> Html.Html msg
link_icons links =
    links
        |> List.map link_icon
        |> div [ class "flex flex-row justify-start" ]


link_icon : Link -> Html.Html msg
link_icon link =
    a
        [ class "flex-shrink  md:text-4xl text-[7vw] p-[.8em] md:p-[1em]"
        , class "text-prime-light-gray dark:text-prime-dark-gray hover:dark:text-prime-dark-white hover:text-prime-light-black"
        , href link.url
        ]
        [ Icon.view link.icon ]


title_font_style : String
title_font_style =
    "flex font-mono select-none md:text-8xl text-[14vw]"
