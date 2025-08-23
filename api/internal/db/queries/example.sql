-- name: GetExample :one
SELECT id, name, created_at, updated_at
FROM example
WHERE id = $1 LIMIT 1;

-- name: ListExamples :many
SELECT id, name, created_at, updated_at
FROM example
ORDER BY created_at DESC;

-- name: CreateExample :one
INSERT INTO example (name)
VALUES ($1)
RETURNING id, name, created_at, updated_at;

-- name: UpdateExample :one
UPDATE example
SET name = $2, updated_at = NOW()
WHERE id = $1
RETURNING id, name, created_at, updated_at;

-- name: DeleteExample :exec
DELETE FROM example
WHERE id = $1;
