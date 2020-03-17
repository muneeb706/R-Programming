## makeCacheMatrix creates a special "matrix", which is really a matrix containing a function to
## set the value of the matrix
## get the value of the matrix
## set the value of the inverse of a matrix
## get the value of the inverse of a matrix

makeCacheMatrix <- function(x = matrix()) {
  inverse <- NULL
  set <- function(y) {
    x <<- y
    inverse <<- NULL
  }
  get <- function()
    x
  setinverse <- function(inv)
    inverse  <<- inv
  getinverse <- function()
    inverse
  list(
    set = set,
    get = get,
    setinverse = setinverse,
    getinverse = getinverse
  )
}


## The following function calculates the inverse of the special "matrix" created with the 
## "makeCacheMatrix" function. 
## However, it first checks to see if the inverse has already been calculated. 
## If so, it gets the inverse from the cache and skips the computation. 
## Otherwise, it calculates the inverse of the data (matrix) and sets the value of the inverse 
## in the cache via the setinverse function.
## Note: following function assumes that given special "matrix" is invertible

cacheSolve <- function(x, ...) {
  inverse <- x$getinverse()
  if (!is.null(inverse)) {
    message("getting cached data")
    return(inverse)
  }
  data <- x$get()
  inverse <- solve(data, ...)
  x$setinverse(inverse)
  inverse
}

#example

# A <- matrix( c(5, 1, 0,
#                3,-1, 2,
#                4, 0,-1), nrow=3, byrow=TRUE)
# cacheMatrix<-makeCacheMatrix()
# cacheMatrix$set(A)
# cacheSolve(cacheMatrix)
