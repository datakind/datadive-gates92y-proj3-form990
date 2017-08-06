import * as React from 'react';
import * as _ from 'lodash';
import { Map } from 'immutable';
import axios from 'axios';
import * as firebase from 'firebase';
import { Filter, FilterOption } from './Filter';

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
}

export class App extends React.Component<undefined, AppState> {

    constructor() {
        super();

        this.state = {
            filters: Map<string, any>(),
            selectedFilters: Map<string, string>(),
            data: [],
            nteeMap: Map<string, string>()
        };

        this._handleApply = this._handleApply.bind(this);
        this._handleOptionChange = this._handleOptionChange.bind(this);
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

        return (
            <div className="app">
                <h2>Find a Match!</h2>
                <div className="filters">
                    <Filter label="State" options={states} handleOptionChange={this._handleOptionChange.bind(this, 'state')} />
                    <Filter label="City" options={cities} handleOptionChange={this._handleOptionChange.bind(this, 'city')} />
                    <Filter label="NTEE Major Group" options={nteeMajorCats} handleOptionChange={this._handleOptionChange.bind(this, 'ntee')} />
                    <Filter label="NTEE Subgroup" options={nteeSubCats} handleOptionChange={this._handleOptionChange.bind(this, 'nteeSub')} />
                </div>
                <button type="button" className="button" onClick={this._handleApply}>Apply</button>
                <h3>Results</h3>
                <table className="data-table">
                    <thead>
                        <tr><th>Name</th><th>Mission</th><th>Year of Formation</th><th>City</th><th>State</th><th>NTEE</th></tr>
                    </thead>
                    <tbody>
                        {this.state.data.map((d, idx) => {
                            return (<tr key={idx}>
                                <td>{this._renderName(d.NAME, d.WEBSITE)}</td>
                                <td>{d.MISSION}</td>
                                <td>{d.FORMYEAR}</td>
                                <td>{d.CITY}</td>
                                <td>{d.STATE}</td>
                                <td>{d.NteeFinal}: {this.state.nteeMap.get(d.NteeFinal, d.NteeFinal)}</td>
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
}
