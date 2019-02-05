import React, { Component } from 'react';
import {Avatar, Card, List, ResourceList, FilterType, Select, TextField, TextStyle, Pagination } from '@shopify/polaris';


class ResourcesList extends Component {
  state = {
    searchValue: '',
    appliedFilters: [
      {
        key: 'accountStatusFilter',
        value: 'Account enabled',
      },
    ],
  };

  handleSearchChange = (searchValue) => {
    this.setState({searchValue});
  };

  handleFiltersChange = (appliedFilters) => {
    this.setState({appliedFilters});
  };

  renderItem = (item) => {
    const {id, url, title, image, published_at} = item;
    const media = <img style={{maxHeight: "60px", width: "60px", "object-fit": "contain"}} src={image.src} />;

    return (
      <ResourceList.Item id={id} url={url} media={media}>
          <TextStyle>{title}</TextStyle>
      </ResourceList.Item>
    );
  };

  render() {
    const resourceName = {
      singular: 'product',
      plural: 'products',
    };

    const items = this.props.products;

    const filters = [
      {
        key: 'orderCountFilter',
        label: 'Number of orders',
        operatorText: 'is greater than',
        type: FilterType.TextField,
      },
      {
        key: 'accountStatusFilter',
        label: 'Account status',
        operatorText: 'is',
        type: FilterType.Select,
        options: ['Enabled', 'Invited', 'Not invited', 'Declined'],
      },
    ];

    const filterControl = (
      <ResourceList.FilterControl
        filters={filters}
        appliedFilters={this.state.appliedFilters}
        onFiltersChange={this.handleFiltersChange}
        searchValue={this.state.searchValue}
        onSearchChange={this.handleSearchChange}
        additionalAction={{
          content: 'Save',
          onAction: () => console.log('New filter saved'),
        }}
      />

    );

    return (
      <Card>
        <ResourceList
          resourceName={resourceName}
          items={items}
          renderItem={this.renderItem}
          filterControl={filterControl}
        />
        <br/>  <br/>
        <Pagination
          hasPrevious
          onPrevious={() => {
            console.log('Previous');
          }}
          hasNext
          onNext={() => {
            console.log('Next');
          }}
        />
          <br/>  <br/>
      </Card>
    );
  }
}

export default ResourcesList;
