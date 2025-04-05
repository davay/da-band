## Status

TODO

## Description

This API server's primary purpose is to receive data from the iOS app and train initial CoreML models
-- since iOS apps can't train initial models, they can only finetune.

## API Design

### Authentication

To make this simpler, there will be no user accounts.
Instead, operations will be tied to a wristband_id (since each dataset and model is specific to a wristband anyway).

The flow will look something like: 
1. Generate a random UUID when creating/connecting a new wristband in the app
2. Use this UUID in all request headers
3. Add basic rate limiting per UUID (e.g., 100 requests per hour)

This should be enough to stop the simplest of attacks -- the goal here isn't to make a commercial product, this is a personal project. 

In the future, we have many options to improve security:
- Implement user accounts; OR 
- Generate the wristband_id by hashing a combination of each uMyo's device IDs (1 wristband can have many uMyos); OR 
- IDs are generated per iOS device, and we can use hardware identifiers + DeviceCheck API for attestation

### Resources

- **Wristbands**: Paired wristbands.
- **Gestures**: User-named gestures. Each gesture is specific to a wristband.
- **Datasets**: EMG data uploaded from iOS devices. Each dataset is specific to a gesture.
- **Models**: Trained CoreML gesture classification models. Each model is specific to a wristband. Must be able to distinguish between gestures.

### Endpoints

All requests must include `X-Wristband-ID: <UUID>` in the headers. Responses will be specific to the wristband.

#### Gestures

##### `GET /gestures`

- List all gestures associated with a wristband.
- Response: `[{id, name, created_at}]`

##### `POST /gestures`

- Create a new gesture
- Body: `{name}`
- Response: `{id, name, created_at}`

##### `DELETE /gestures/{gesture_id}`

- Delete a gesture and all of its associated datasets and models (DANGEROUS!)
- Response: `204 No Content`

#### Datasets

##### `POST /datasets/{gesture_id}`

- Upload EMG data samples for a specific gesture
- Body: CSV file
- Response: `{id, gesture_id, created_at}`

#### Models

##### `POST /models/train`

- Triggers training a new model
- Body: `{gestures: [gesture_ids]}` (which gestures to include, maybe make it optional to use all gestures?)
- Response: `{id, version, status: "training"}`

##### `GET /models/latest/status`

- Get status of latest model (e.g., training progress, ETA)
- Response: `{id, version, status, progress, eta}`

##### `GET /models/{model_id}/status`

- Get status of specific model (e.g., training progress, ETA)
- Response: `{id, version, status, progress, eta}`

##### `GET /models/latest`

- Download latest completed CoreML model
- Response: CoreML model file

##### `GET /models/{model_id}`

- Download specific completed CoreML model
- Response: CoreML model file

## DB Design

- Wristband:
    - id | PK
    - created_at

- Gesture:
    - id | PK
    - wristband_id | FK
    - name
    - created_at

- Dataset: 
    - id | PK
    - gesture_id | FK
    - file_path (datasets will be stored as CSV on the server)
    - created_at

- Model: 
    - id | PK
    - wristband_id | FK
    - version
    - file_path (trained CoreML models)
    - created_at

- ModelGesture: (junction table, to track which gestures can be recognized by a model, each model can have many versions)
    - model_id | PK, FK
    - gesture_id | PK, FK

