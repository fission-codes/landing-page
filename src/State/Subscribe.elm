module State.Subscribe exposing (..)

import Fathom
import Http
import Ports
import RemoteAction exposing (RemoteAction(..))
import Return
import Types exposing (..)
import Validation exposing (Validated(..))



-- 🛠


gotResponse : Result Http.Error () -> Manager
gotResponse result model =
    case Debug.log "Http result" result of
        Ok () ->
            Return.singleton { model | subscribing = Succeeded }

        Err err ->
            -- Return.singleton { model | subscribing = Failed "HTTP Request Failed" }
            -- NOTE: We always get an error because of CORS issues with sendinblue.
            Return.singleton { model | subscribing = Succeeded }


gotInput : String -> Manager
gotInput input model =
    Return.singleton
        { model
            | subscribing = RemoteAction.recoverFromFailure model.subscribing
            , subscribeToEmail = Validation.email input
        }


subscribe : Manager
subscribe model =
    case model.subscribeToEmail of
        Valid email ->
            ( { model | subscribing = InProgress }
            , Cmd.batch
                [ Http.post
                    { url = "https://5d04d668.sibforms.com/serve/MUIEAH9z71F3-xucvdxYTZ9rKE0dHzCDikuQqcnxjAyY3T2NBmxUOklz4XijWG0ML4E_sHeoyq1PBQM_-PpLAkraiFa51bhHUp64vZfo6XT38fr4H2eFpxjCSgcIpFDo1KFyRr3hWfQ4KZ8TCPG0YVqWEYDQVVGW_ZGwBgJcgjaLibCPjvshJzIeUYDSQPg2jHyvYshB1YuqPopz"
                    , body =
                        Http.multipartBody
                            [ Http.stringPart "EMAIL" email
                            , Http.stringPart "html_type" "simple"
                            , Http.stringPart "locale" "en"
                            ]
                    , expect =
                        Http.expectWhatever GotSubscribeResponse
                    }

                --
                , Ports.setFathomGoal Fathom.goals.emailSubscription
                ]
            )

        _ ->
            Return.singleton { model | subscribing = Failed "Invalid input" }
