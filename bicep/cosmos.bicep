@description('Location to deploy db to')
param location string = resourceGroup().location

@description('The name for the database')
param databaseName string = 'Alchemy_POC'

@description('The account name for the cosmos database')
param accountName string = 'some-cosmos-db'

var locations = [
  {
    locationName: location
    failoverPriority: 0
    isZoneRedundant: false
  }
]

resource cosmosDb 'Microsoft.DocumentDB/databaseAccounts@2022-05-15' = {
  name: accountName
  location: location
  kind: 'GlobalDocumentDB'
  properties: {
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
    databaseAccountOfferType: 'Standard'
    locations: locations
    enableAutomaticFailover: true
    capabilities: [
      {
        name: 'EnableServerless'
      }
    ]
  }
}

resource cosmosDbDatabase 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2022-05-15' = {
  parent: cosmosDb
  name: databaseName
  properties: {
    resource: {
      id: databaseName
    }
  }
}

var nominationContainerName ='nominations'
@description('Set up nominations container')
resource cosmosDbContainerNominations 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2022-05-15' = {
  parent: cosmosDbDatabase
  name: nominationContainerName
  properties: {
    resource: {
      id: nominationContainerName
      partitionKey: {
        paths: [
          '/nominatorEmail'
        ]
        kind: 'Hash'
      }
      indexingPolicy: {
        indexingMode: 'consistent'
        includedPaths: [
          {
            path: '/*'
          }
        ]
        excludedPaths: [
          {
            path: '/_etag/?'
          }
        ]
      }
    }
  }
}

var nominationsOverviewName ='nominationsOverview'
@description('Set up nominationsOverview container')
resource cosmosDbContainerNominationsOverview 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2022-05-15' = {
  parent: cosmosDbDatabase
  name: nominationsOverviewName
  properties: {
    resource: {
      id: nominationsOverviewName
      partitionKey: {
        paths: [
          '/email'
          '/market'
        ]
        kind: 'MultiHash'
        version: 2
      }
      indexingPolicy: {
        indexingMode: 'consistent'
        includedPaths: [
          {
            path: '/*'
          }
        ]
        excludedPaths: [
          {
            path: '/_etag/?'
          }
        ]
      }
    }
  }
}

var feedbacksName ='feedbacks'
@description('Set up feedbacks container')
resource cosmosDbContainerFeedbacksV2 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2022-05-15' = {
  parent: cosmosDbDatabase
  name: feedbacksName
  properties: {
    resource: {
      id: feedbacksName
      partitionKey: {
        paths: [
          '/receiver'
          '/sender'
        ]
        kind: 'MultiHash'
        version: 2
      }
      indexingPolicy: {
        indexingMode: 'consistent'
        includedPaths: [
          {
            path: '/*'
          }
        ]
        excludedPaths: [
          {
            path: '/_etag/?'
          }
        ]
      }
    }
  }
}

var praiseItemsName ='praiseItems'
@description('Set up praiseItems container')
resource cosmosDbContainerPraiseItemsV2 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2022-05-15' = {
  parent: cosmosDbDatabase
  name: praiseItemsName
  properties: {
    resource: {
      id: praiseItemsName
      partitionKey: {
        paths: [
          '/id'
        ]
        kind: 'MultiHash'
        version: 2
      }
      indexingPolicy: {
        indexingMode: 'consistent'
        includedPaths: [
          {
            path: '/*'
          }
        ]
        excludedPaths: [
          {
            path: '/_etag/?'
          }
        ]
      }
    }
  }
}

var praisePeopleName ='praisePeople'
@description('Set up praise container')
resource cosmosDbContainerPraisePeopleV2 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2022-05-15' = {
  parent: cosmosDbDatabase
  name: praisePeopleName
  properties: {
    resource: {
      id: praisePeopleName
      partitionKey: {
        paths: [
          '/partitionId'
        ]
        kind: 'MultiHash'
        version: 2
      }
      indexingPolicy: {
        indexingMode: 'consistent'
        includedPaths: [
          {
            path: '/*'
          }
        ]
        excludedPaths: [
          {
            path: '/_etag/?'
          }
        ]
      }
    }
  }
}

var snapshotsName ='snapshots'
@description('Set up snapshots container')
resource cosmosDbContainerSnapshotsV2 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2022-05-15' = {
  parent: cosmosDbDatabase
  name: snapshotsName
  properties: {
    resource: {
      id: snapshotsName
      partitionKey: {
        paths: [
          '/requestor/email'
        ]
        kind: 'Hash'
        version: 2
      }
      indexingPolicy: {
        indexingMode: 'consistent'
        includedPaths: [
          {
            path: '/*'
          }
        ]
        excludedPaths: [
          {
            path: '/_etag/?'
          }
        ]
      }
    }
  }
}

