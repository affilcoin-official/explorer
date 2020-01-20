(angular.module 'ethExplorer.main', []).controller 'mainCtrl', ($rootScope, $scope, $location) ->
  load-block = ([item, ...items], cb)->
      return cb null if not item?
      console.log item
      err, item <- $rootScope.web3.eth.getBlock $scope.blockNum - item
      return cb err if err?
      $scope.blocks.push item
      err <- load-block items
      return cb err if err?
      cb null
  init = ->
    cb = console.log
    $rootScope.loading = true
    err, number <- $rootScope.web3.eth.getBlockNumber
    return cb err if err?
    $scope.blockNum = number
    $scope.blocks = []
    err <- load-block [0 to 10] 
    return cb err if err?
    <- $rootScope.safe-apply
    $rootScope.loading = no
    console.log \loadingstop, err
  console.log \init
  err <- init
  console.log err

(angular.module 'ethExplorer.search', []).controller 'searchCtrl', ($rootScope, $scope, $location) ->
  goToBlockInfos = (requestStr) ->
    $location.path '/block/' + requestStr
  goToAddrInfos = (requestStr) ->
    $location.path '/address/' + requestStr
  goToTxInfos = (requestStr) ->
    $location.path '/transaction/' + requestStr
  $scope.processRequest = ->
    requestStr = ($scope.ethRequest.split '0x').join ''
    if requestStr.length is 40 then goToAddrInfos requestStr
    else if //[0-9a-zA-Z]{64}?//.test requestStr then goToTxInfos '0x' + requestStr 
    else if //[0-9]{1,7}?//.test requestStr then goToBlockInfos requestStr
    else if (parseInt requestStr) > 0 then goToBlockInfos parseInt requestStr
    else alert 'Don\'t know how to handle ' + requestStr
