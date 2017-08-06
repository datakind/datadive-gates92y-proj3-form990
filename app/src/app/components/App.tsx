import * as React from 'react';
import * as _ from 'lodash';
import { Map } from 'immutable';
import axios from 'axios';
import * as firebase from 'firebase';
import { Filter, FilterOption } from './Filter';

const OPERATING_BUDGET_MINS = [
    { key: '', value: 'No Min' },
    { key: 10000, value: '10,000' },
    { key: 100000, value: '100,000' },
    { key: 1000000, value: '1,000,000' },
    { key: 10000000, value: '10,000,000' }
], OPERATING_BUDGET_MAXES = [
    { key: '', value: 'No Max' },
    { key: 10000, value: '10,000' },
    { key: 100000, value: '100,000' },
    { key: 1000000, value: '1,000,000' },
    { key: 10000000, value: '10,000,000' }
], COLUMNS = [
    { key: 'NteeFinal', value: 'NTEE' },
    { key: 'NAME', value: 'Name' },
    { key: 'CITY', value: 'City' },
    { key: 'STATE', value: 'State' },
    { key: 'MISSION', value: 'Mission' },
    { key: 'FORMYEAR', value: 'Year of Formation' },
    { key: 'GROSSRECEIPTS', value: 'Operating Budget' }
], SORT_DIR = [
    { key: 1, value: 'Ascending' },
    { key: -1, value: 'Descending' },
];

interface Organization {
    name: string;
    website: string;
    mission: string;
    yearOfFormation: number;
    state: string;
    city: string;
    ntee: string;
}

interface AppState {
    filters: Map<string, any>;
    selectedFilters: Map<string, string>;
    data: any[];
    nteeMap: Map<string, string>;
    sortCol: string;
    sortDirection: number;
}

export class App extends React.Component<undefined, AppState> {

    constructor() {
        super();

        this.state = {
            filters: Map<string, any>(),
            selectedFilters: Map<string, string>(),
            data: [],
            nteeMap: Map<string, string>(),
            sortCol: 'NteeFinal',
            sortDirection: 1
        };

        this._handleApply = this._handleApply.bind(this);
        this._handleOptionChange = this._handleOptionChange.bind(this);
        this._handleSortChange = this._handleSortChange.bind(this);
        this._handleSortDirectionChange = this._handleSortDirectionChange.bind(this);
    }

    componentDidMount() {
        axios.get('filters').then(results => {
            var filters = this.state.filters;
            var nteeMap = Map<string, string>();
            var cities = Map<string, FilterOption[]>();
            var states: FilterOption[] = _.map(results.data.filters.locations, (values: any, state: string) => {
                var stateCities = Object.keys(values).map(city => { return { key: city, value: city } })
                    .sort((a, b) => { return a.value.toLowerCase().localeCompare(b.value.toLowerCase()) });
                cities = cities.set(state, stateCities);

                return { key: state, value: state };
            }).sort((a, b) => { return a.value.toLowerCase().localeCompare(b.value.toLowerCase()) });
            filters = filters.set('states', states).set('cities', cities);

            var subCats = Map<string, FilterOption[]>();
            var ntee: FilterOption[] = _.map(results.data.filters.ntee, (values: any, ntee: string) => {
                var prefix = values.prefix;
                var nteeSubCats = _.map(values.subCategories, (code: string, subCat: string) => {
                    nteeMap = nteeMap.set(code, `${ntee} - ${subCat}`);
                    return { key: code, value: subCat };
                }).sort((a, b) => { return a.value.toLowerCase().localeCompare(b.value.toLowerCase()) });
                subCats = subCats.set(prefix, nteeSubCats);

                return { key: prefix, value: ntee };
            }).sort((a, b) => { return a.value.toLowerCase().localeCompare(b.value.toLowerCase()) });
            filters = filters.set('ntee', ntee).set('nteeSub', subCats);

            this.setState({ ...this.state, filters, nteeMap });
        });
    }

    render() {
        let states = this.state.filters.get('states', []);
        let state = this.state.selectedFilters.get('state');
        let cities = state && this.state.filters.get('cities').get(state, []) || [];
        let nteeMajorCats = this.state.filters.get('ntee', []);
        let nteeMajorCat = this.state.selectedFilters.get('ntee');
        let nteeSubCats = nteeMajorCat && this.state.filters.get('nteeSub').get(nteeMajorCat, []) || [];
        let results = this._getSortedData(this.state.data, this.state.sortCol, this.state.sortDirection);

        return (
            <div className="app">
                <h2>Find an Organization!</h2>
                <div className="filters">
                    <Filter label="State" options={states} handleOptionChange={this._handleOptionChange.bind(this, 'state')} showAny={true} />
                    <Filter label="City" options={cities} handleOptionChange={this._handleOptionChange.bind(this, 'city')} showAny={true} />
                    <Filter label="NTEE Major Group" options={nteeMajorCats} handleOptionChange={this._handleOptionChange.bind(this, 'ntee')} showAny={true} />
                    <Filter label="NTEE Subgroup" options={nteeSubCats} handleOptionChange={this._handleOptionChange.bind(this, 'nteeSub')} showAny={true} />
                    <Filter label="Min Operating Budget" options={OPERATING_BUDGET_MINS} handleOptionChange={this._handleOptionChange.bind(this, 'minBudget')} />
                    <Filter label="Max Operating Budget" options={OPERATING_BUDGET_MAXES} handleOptionChange={this._handleOptionChange.bind(this, 'maxBudget')} />
                </div>
                <button type="button" className="button" onClick={this._handleApply}>Apply</button>
                <h3 className="results-header">
                    Results ({this.state.data.length})
                    <div className="sorters">
                        <Filter label="Sort By" options={COLUMNS} handleOptionChange={this._handleSortChange} />
                        <Filter label="Asc/Desc" options={SORT_DIR} handleOptionChange={this._handleSortDirectionChange} />
                    </div>
                </h3>
                <table className="data-table">
                    <thead>
                        <tr>{COLUMNS.map(c => { return (<th>{c.value}</th>); })}</tr>
                    </thead>
                    <tbody>
                        {results.map((d, idx) => {
                            return (<tr key={idx}>
                                <td>{this.state.nteeMap.get(d.NteeFinal, d.NteeFinal)} ({d.NteeFinal})</td>
                                <td>{this._renderName(d.NAME, d.WEBSITE)}</td>
                                <td>{d.CITY}</td>
                                <td>{d.STATE}</td>
                                <td>{d.MISSION}</td>
                                <td>{d.FORMYEAR}</td>
                                <td>{d.GROSSRECEIPTS}</td>
                            </tr>);
                        })}
                    </tbody>
                </table>
            </div>
        );
    }

    _renderName(name: string, website: string): JSX.Element {
        if (website === 'N/A' || website === 'NA') {
            return <span>{name}</span>;
        }

        let url = website.startsWith('http://') ? website : `http://${website}`;
        return <a href={url} target="_blank">{name}</a>;
    }

    _getSortedData(data: any[], column: string, direction: number): any[] {
        var nteeColumn = column === 'NteeFinal';
        var results = nteeColumn ? _.sortBy(data, [(d: any) => this.state.nteeMap.get(d.NteeFinal, d.NteeFinal)]) : _.sortBy(data, column);
        if (direction < 0) {
            return results.reverse();
        }
        return results;
    }

    _handleOptionChange(filter: string, value: string) {
        var newSelectedFilters = this.state.selectedFilters.set(filter, value);
        if (filter === 'state') {
            newSelectedFilters = newSelectedFilters.set('city', '');
        }
        if (filter === 'ntee') {
            newSelectedFilters = newSelectedFilters.set('nteeSub', '');
        }
        this.setState({ ...this.state, selectedFilters: newSelectedFilters });
    }

    _handleApply() {
        var params = this.state.selectedFilters.toObject();
        axios.get('data', { params })
            .then(results => {
                this.setState({ ...this.state, data: results.data });
            });
    }

    _handleSortChange(value: string) {
        this.setState({ ...this.state, sortCol: value });
    }

    _handleSortDirectionChange(value: number) {
        this.setState({ ...this.state, sortDirection: value });
    }
}
