package users_transport_http

import (
	"encoding/json"
	"fmt"
	"net/http"

	core_logger "github.com/rafchibuz/ToDoApp/internal/core/logger"
)

type CreateUserRequest struct {
	FullName    string  `json:"full_name"`
	PhoneNumber *string `json:"phone_number"`
}

type CreateUserResponse struct {
	ID          int     `json:"id"`
	Version     int     `json:"version"`
	FullName    string  `json:"full_name"`
	PhoneNumber *string `json:"phone_number"`
}

func (h *UsersHTTPHandler) CreateUser(rw http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	log := core_logger.FromContext(ctx)

	log.Debug("Received CreateUser request")
	var request CreateUserRequest
	if err := json.NewDecoder(r.Body).Decode(&request); err != nil {
		fmt.Println("Error decoding request body:", err)
	}

	rw.WriteHeader(http.StatusOK)
}
