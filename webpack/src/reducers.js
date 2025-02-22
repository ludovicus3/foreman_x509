import { combineReducers } from 'redux';
import EmptyStateReducer from './Components/EmptyState/EmptyStateReducer';

const reducers = {
  foremanX509: combineReducers({
    emptyState: EmptyStateReducer,
  }),
};

export default reducers;
